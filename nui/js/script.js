// events
window.addEventListener("message", (event) => {
  switch (event.data.action) {
    case "open":
      Open(event.data);
      break;
    case "close":
      Close();
      break;
    case "setup":
      Setup(event.data);
      break;
  }
});

// functions
const Open = (data) => {
  $(".playerlist-toggle").fadeIn(0);
  $("#total-players").html("<p>" + data.players + " / " + data.maxPlayers + "</p>");
};

const Close = () => {
  $(".playerlist-toggle").fadeOut(0);
  $.post(`https://${GetParentResourceName()}/closelist`);
};

const Setup = (data) => {
  let playerlistHtml = "";
  $.each(data.items, (index, value) => {
    if (value != null) {
      playerlistHtml += `
        <div class="playerlist-data">
          <div class="data-title">
              <p>[${value.src}] ${value.iden}</p>
          </div>
          <div class="data-value"></div>
        </div>
      `;
    }
  });  
  $(".playerlist-info").html(playerlistHtml);
};

// keypress (onkeydown)
document.onkeydown = function (event) {
  const charCode = event.key;
  if (charCode == "Escape") {
    Close();
  } else if (charCode == "Backspace") {
    Close();
  } 
};

$(document).ready(function () {
  // Fetch configuration from the config.json file
  $.getJSON('./config.json', function (config) {
      // Update the playerlist-header with the configurable value
      $('.playerlist-header p').text(config.headerText);
  }).fail(function () {
      console.error("Failed to load configuration file.");
  });
});
