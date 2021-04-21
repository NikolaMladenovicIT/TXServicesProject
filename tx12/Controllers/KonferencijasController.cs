using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using tx12.Models;

namespace tx12.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KonferencijasController : ControllerBase
    {
        private readonly ConferenceContext _context;

        public KonferencijasController(ConferenceContext context)
        {
            _context = context;
        }

        // GET: api/Konferencijas
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Konferencija>>> GetKonferencijas()
        {
            return await _context.Konferencijas.ToListAsync();
        }

        // GET: api/Konferencijas/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Konferencija>> GetKonferencija(int id)
        {
            var konferencija = await _context.Konferencijas.SingleAsync(konf => konf.IdBroj == id);

            _context.Entry(konferencija)
                    .Collection(konf => konf.OdrzavaSes)
                    .Load();


            if (konferencija == null)
            {
                return NotFound();
            }

            return konferencija;
        }

        // PUT: api/Konferencijas/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutKonferencija(int id, Konferencija konferencija)
        {
            if (id != konferencija.IdBroj)
            {
                return BadRequest();
            }

            _context.Entry(konferencija).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!KonferencijaExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Konferencijas
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<Konferencija>> PostKonferencija(Konferencija konferencija)
        {
            //Auto-generate new ID_Broj by incrementing max id from Konferencija table
            var max = _context.Konferencijas.Max(konf => konf.IdBroj);
            konferencija.IdBroj = ++max;
            _context.Konferencijas.Add(konferencija);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (KonferencijaExists(konferencija.IdBroj))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetKonferencija", new { id = konferencija.IdBroj }, konferencija);
        }

        // DELETE: api/Konferencijas/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Konferencija>> DeleteKonferencija(int id)
        {
            var konferencija = await _context.Konferencijas.FindAsync(id);
            if (konferencija == null)
            {
                return NotFound();
            }

            _context.Konferencijas.Remove(konferencija);
            await _context.SaveChangesAsync();

            return konferencija;
        }

        private bool KonferencijaExists(int id)
        {
            return _context.Konferencijas.Any(e => e.IdBroj == id);
        }
    }
}
