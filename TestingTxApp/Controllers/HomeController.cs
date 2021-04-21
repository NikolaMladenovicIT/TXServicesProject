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
    public class HomeController : Controller
    {
        private readonly ConferenceContext _context;
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            return View();
        }
        public IActionResult About()
        {
            return View();
        }
        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

        KonferencijaApi api = new KonferencijaApi();
        public async Task<ActionResult> AllKonferencijas()
        {
            List<Konferencija> konferencije = new List<Konferencija>();
            var client = api.Initial();
            var res = await client.GetAsync("api/Konferencijas");
            if (res.IsSuccessStatusCode)
            {
                var results = res.Content.ReadAsStringAsync().Result;
                konferencije = JsonConvert.DeserializeObject<List<Konferencija>>(results);
            }
            return View(konferencije);
        }

        public IActionResult KerirajKonferenciju()
        {
            return View();
        }
        [HttpPost]
        public IActionResult KerirajKonferenciju(Konferencija konferencija)
        {
            
            HttpClient client = api.Initial();
            var postTask = client.PostAsJsonAsync<Konferencija>("api/Konferencijas", konferencija);
            postTask.Wait();
            var res = postTask.Result;
            if (res.IsSuccessStatusCode)
            {
                return RedirectToAction("AllKonferencijas");
            }
            return RedirectToAction("Greska");
        }

        public async Task<ActionResult> DetaljiKonferencije(int Id)
        {
            var konferencija = new Konferencija();
            var client = api.Initial();
            var res = await client.GetAsync($"api/Konferencijas/{Id}");
            if (res.IsSuccessStatusCode)
            {
                var results = res.Content.ReadAsStringAsync().Result;
                konferencija = JsonConvert.DeserializeObject<Konferencija>(results);
            }
            return View(konferencija);
        }

        public async Task<ActionResult> DeleteKonferenciju(int Id)
        {
            var konferencija = new Konferencija();
            HttpClient client = api.Initial();
            HttpResponseMessage res = await client.DeleteAsync($"api/Konferencijas/{Id}");
            return View("DeleteKonferenciju");
        }

        public IActionResult IzmeniKonferenciju(int Id)
        {

            var client = api.Initial();
            List<Organizator> organizatori = new List<Organizator>();
            var resOrganizatori = client.GetAsync("api/Organizators");
            resOrganizatori.Wait();
            var resultOrganizatori = resOrganizatori.Result;
            if (resultOrganizatori.IsSuccessStatusCode)
            {
                var results = resultOrganizatori.Content.ReadAsStringAsync().Result;
                organizatori = JsonConvert.DeserializeObject<List<Organizator>>(results);
            }
            ViewBag.ListaOrganizatora = organizatori;

            var konferencija = new Konferencija();
            var resTask = client.GetAsync($"api/Konferencijas/{Id}");
            resTask.Wait();
            var result = resTask.Result;
            if (result.IsSuccessStatusCode)
            {
                var readTask = result.Content.ReadAsAsync<Konferencija>();
                readTask.Wait();
                konferencija = readTask.Result;
            }
            return View(konferencija);
           
        }

        [HttpPost]
        public IActionResult IzmeniKonferenciju(Konferencija konferencija)
        {
           
            var client = api.Initial();
            var putTask = client.PutAsJsonAsync<Konferencija>($"api/Konferencijas/{konferencija.IdBroj}", konferencija);
            putTask.Wait();
            var res = putTask.Result;
            if (res.IsSuccessStatusCode)
            {
                return RedirectToAction("AllKonferencijas");
            }
            return View(konferencija);




        }
    }
}
