using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using TestingTxApp.Models;
using tx12.Models;

namespace TestingTxApp.Controllers
{
    public class OrganizatorController : Controller
    {
        private readonly ConferenceContext _context;

        KonferencijaApi api = new KonferencijaApi();
        public async Task<ActionResult> AllOrganizators()
        {
            List<Organizator> organizatori = new List<Organizator>();
            var client = api.Initial();
            var res = await client.GetAsync("api/Organizators");
            if (res.IsSuccessStatusCode)
            {
                var results = res.Content.ReadAsStringAsync().Result;
                organizatori = JsonConvert.DeserializeObject<List<Organizator>>(results);
            }
            return View(organizatori);
        }

        public IActionResult KreirajOrganizatora()
        {
            return View();
        }
        [HttpPost]
        public IActionResult KreirajOrganizatora(Organizator organizator)
        {

            HttpClient client = api.Initial();
            var postTask = client.PostAsJsonAsync<Organizator>("api/Organizators", organizator);
            postTask.Wait();
            var res = postTask.Result;
            if (res.IsSuccessStatusCode)
            {
                return RedirectToAction("AllOrganizators");
            }
            return RedirectToAction("Greska");
        }

        public async Task<ActionResult> DetaljiOrganizatora(int Id)
        {
            var organizator = new Organizator();
            var client = api.Initial();
            var res = await client.GetAsync($"api/Organizators/{Id}");
            if (res.IsSuccessStatusCode)
            {
                var results = res.Content.ReadAsStringAsync().Result;
                organizator = JsonConvert.DeserializeObject<Organizator>(results);
            }
            return View(organizator);
        }

        public IActionResult IzmeniOrganizatora(int Id)
        {
            var organizator = new Organizator();
            var client = api.Initial();
            var resTask = client.GetAsync($"api/Organizators/{Id}");
            var result = resTask.Result;
            if (result.IsSuccessStatusCode)
            {
                var readTask = result.Content.ReadAsAsync<Organizator>();
                readTask.Wait();
                organizator = readTask.Result;
            }
            return View(organizator);
        }
        [HttpPost]
        public IActionResult IzmeniOrganizatora(Organizator organizator)
        {
            var client = api.Initial();
            var putTask = client.PutAsJsonAsync<Organizator>($"api/Organizators/{organizator.IdOrganizatora}", organizator);
            putTask.Wait();
            var res = putTask.Result;
            if (res.IsSuccessStatusCode)
            {
                return RedirectToAction("AllOrganizators");
            }
            return View(organizator);
        }

        public async Task<ActionResult> DeleteOrganizatora(int Id)
        {
            var organizator = new Organizator();
            HttpClient client = api.Initial();
            HttpResponseMessage res = await client.DeleteAsync($"api/Organizators/{Id}");
            return View("DeleteOrganizatora");
        }
    }
}
