

using SchedulingHub.Core.Entities;
using SchedulingHub.Core.Interfaces;
using SchedulingHub.Core.Services;
using SchedulingHub.Infrastructure;
using SchedulingHub.Infrastructure.Repositories;

var builder = WebApplication.CreateBuilder(args); 
builder.Services.AddControllers();


// Accessing configuration
var configuration = builder.Configuration;

// Register the SqlDbContext
builder.Services.AddScoped<SqlDbContext>(provider => new SqlDbContext(configuration.GetConnectionString("DefaultConnection")));

// Register the repository


builder.Services.AddScoped<IRepository<Schedule>, ScheduleRepository>();

builder.Services.AddScoped<ISSISDependencyRepository, SSISDependencyRepository>();
builder.Services.AddScoped<ISSISDependencyManager, SSISDependencyManager>();

builder.Services.AddScoped<ISSISJobRepository, SSISJobRepository>();
builder.Services.AddScoped<ISSISJobManager, SSISJobManager>();


builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowBlazor",
        builder => builder.WithOrigins("http://localhost:5157")  
                          .AllowAnyMethod()
                          .AllowAnyHeader());
});

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
	app.UseSwagger();
	app.UseSwaggerUI();
}


app.UseCors("AllowBlazor");  
app.UseHttpsRedirection();
app.UseRouting();
app.UseAuthorization(); 
app.MapControllers(); 
app.Run();
