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
    public class UcesniksController : ControllerBase
    {
        private readonly ConferenceContext _context;

        public UcesniksController(ConferenceContext context)
        {
            _context = context;
        }

        // GET: api/Ucesniks
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Ucesnik>>> GetUcesniks()
        {
            return await _context.Ucesniks.ToListAsync();
        }

        // GET: api/Ucesniks/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Ucesnik>> GetUcesnik(int id)
        {
            //var ucesnik = await _context.Ucesniks.FindAsync(id);
            var ucesnik = await _context.Ucesniks.SingleAsync(uces => uces.IdUcesnika == id);

            //Loading related data | Explicit loading all authors with Article no=1
            _context.Entry(ucesnik)
                    .Collection(uces => uces.AutorRadas)
                    .Query()
                    .Where(auth=>auth.BrRada==1)
                    .Load();

            if (ucesnik == null)
            {
                return NotFound();
            }

            return ucesnik;
        }

        // PUT: api/Ucesniks/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutUcesnik(int id, Ucesnik ucesnik)
        {
            if (id != ucesnik.IdUcesnika)
            {
                return BadRequest();
            }

            _context.Entry(ucesnik).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UcesnikExists(id))
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

        // POST: api/Ucesniks
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<Ucesnik>> PostUcesnik(Ucesnik ucesnik)
        {
            _context.Ucesniks.Add(ucesnik);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetUcesnik", new { id = ucesnik.IdUcesnika }, ucesnik);
        }

        // DELETE: api/Ucesniks/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Ucesnik>> DeleteUcesnik(int id)
        {
            var ucesnik = await _context.Ucesniks.FindAsync(id);
            if (ucesnik == null)
            {
                return NotFound();
            }

            _context.Ucesniks.Remove(ucesnik);
            await _context.SaveChangesAsync();

            return ucesnik;
        }

        private bool UcesnikExists(int id)
        {
            return _context.Ucesniks.Any(e => e.IdUcesnika == id);
        }
    }
}
