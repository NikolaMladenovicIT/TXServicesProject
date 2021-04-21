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
    public class UcesnikController : Controller
    {
        private readonly ConferenceContext _context;

        KonferencijaApi api = new KonferencijaApi();
        public async Task<ActionResult> AllUcesniks()
        {
            List<Ucesnik> ucesnici = new List<Ucesnik>();
            var client = api.Initial();
            var res = await client.GetAsync("api/Ucesniks");
            if (res.IsSuccessStatusCode)
            {
                var results = res.Content.ReadAsStringAsync().Result;
                ucesnici = JsonConvert.DeserializeObject<List<Ucesnik>>(results);
            }
            return View(ucesnici);
        }

        public IActionResult KreirajUcesnika()
        {
            return View();
        }
        [HttpPost]
        public IActionResult KreirajUcesnika(Ucesnik ucesnik)
        {

            HttpClient client = api.Initial();
            var postTask = client.PostAsJsonAsync<Ucesnik>("api/Ucesniks", ucesnik);
            postTask.Wait();
            var res = postTask.Result;
            if (res.IsSuccessStatusCode)
            {
                return RedirectToAction("AllUcesniks");
            }
            return RedirectToAction("Greska");
        }

        public async Task<ActionResult> DetaljiUcesnika(int Id)
        {
            var ucesnik = new Ucesnik();
            var client = api.Initial();
            var res = await client.GetAsync($"api/Ucesniks/{Id}");
            if (res.IsSuccessStatusCode)
            {
                var results = res.Content.ReadAsStringAsync().Result;
                ucesnik = JsonConvert.DeserializeObject<Ucesnik>(results);
            }
            return View(ucesnik);
        }

        public IActionResult IzmeniUcesnika(int Id)
        {
            var ucesnik = new Ucesnik();
            var client = api.Initial();
            var resTask = client.GetAsync($"api/Ucesniks/{Id}");
            var result = resTask.Result;
            if (result.IsSuccessStatusCode)
            {
                var readTask = result.Content.ReadAsAsync<Ucesnik>();
                readTask.Wait();
                ucesnik = readTask.Result;
            }
            return View(ucesnik);
        }
        [HttpPost]
        public IActionResult IzmeniUcesnika(Ucesnik ucesnik)
        {
            var client = api.Initial();
            var putTask = client.PutAsJsonAsync<Ucesnik>($"api/Ucesniks/{ucesnik.IdUcesnika}", ucesnik);
            putTask.Wait();
            var res = putTask.Result;
            if (res.IsSuccessStatusCode)
            {
                return RedirectToAction("AllUcesniks");
            }
            return View(ucesnik);
        }

        public async Task<ActionResult> DeleteUcesnika(int Id)
        {
            var ucesnik = new Ucesnik();
            HttpClient client = api.Initial();
            HttpResponseMessage res = await client.DeleteAsync($"api/Ucesniks/{Id}");
            return View("DeleteUcesnika");
        }
    }
}
