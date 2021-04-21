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
    public class OrganizatorsController : ControllerBase
    {
        private readonly ConferenceContext _context;

        public OrganizatorsController(ConferenceContext context)
        {
            _context = context;
        }

        // GET: api/Organizators
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Organizator>>> GetOrganizators()
        {
            return await _context.Organizators.ToListAsync();
        }

        // GET: api/Organizators/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Organizator>> GetOrganizator(int id)
        {
            var organizator = await _context.Organizators.FindAsync(id);


            _context.Entry(organizator)
                   .Collection(org => org.Konferencijas)
                   .Query()
                   .Where(konf=>konf.Naziv.Contains(""))
                   .Load();

            _context.Entry(organizator)
                   .Collection(org => org.Konferencijas)
                   .Query()
                   .Include(konf=>konf.OdrzavaSes)
                   .Load();

            if (organizator == null)
            {
                return NotFound();
            }

            return organizator;
        }

        // PUT: api/Organizators/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutOrganizator(int id, Organizator organizator)
        {
            if (id != organizator.IdOrganizatora)
            {
                return BadRequest();
            }

            _context.Entry(organizator).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!OrganizatorExists(id))
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

        // POST: api/Organizators
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<Organizator>> PostOrganizator(Organizator organizator)
        {
            var max = _context.Organizators.Max(konf => konf.IdOrganizatora);
            organizator.IdOrganizatora = ++max;
            _context.Organizators.Add(organizator);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (OrganizatorExists(organizator.IdOrganizatora))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetOrganizator", new { id = organizator.IdOrganizatora }, organizator);
        }

        // DELETE: api/Organizators/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Organizator>> DeleteOrganizator(int id)
        {
            var organizator = await _context.Organizators.FindAsync(id);
            if (organizator == null)
            {
                return NotFound();
            }

            _context.Organizators.Remove(organizator);
            await _context.SaveChangesAsync();

            return organizator;
        }

        private bool OrganizatorExists(int id)
        {
            return _context.Organizators.Any(e => e.IdOrganizatora == id);
        }
    }
}
