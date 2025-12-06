class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https://www.ferronweb.org/"
  url "https://ghfast.top/https://github.com/ferronweb/ferron/archive/refs/tags/2.2.1.tar.gz"
  sha256 "d31701cd525ecfde3d09974a76cb1e23779b69dcca7d5f43121f78b757566176"
  license "MIT"
  head "https://github.com/ferronweb/ferron.git", branch: "develop-2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "399762b156c2bccfdec46c796abd1dea41700954004f0784065616601374d75e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99eacda1c7d0d590f90e9a7326a1b4029c4838d574fa13847b3e44e40405bcc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46743c41aff37faf8a8ab6f2b91d54965624c9a8c6a877868fc1e87acd24d117"
    sha256 cellar: :any_skip_relocation, sonoma:        "95692dc88fc20d3428c237e09ca87cb0606c13cd884747bc394ef7f9c621d0a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "763ffcd9223d2f3ba9dbfa4d33cdf294bfb2cc39450dac61fe2654838693f2a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44c70ae63807084bfdb6e4360d33f35cb8fc5cd1c28e38c8e9dda97b77bf39c7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "ferron")
  end

  test do
    port = free_port

    (testpath/"ferron.yaml").write "global: {\"port\":#{port}}"
    expected_output = <<~HTML.chomp
      <!doctype html>
             <html lang="en">
                 <head>
                     <meta charset="UTF-8" />
                     <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                     <title>404 Not Found</title>
                     <style>html,
      body {
          margin: 0;
          padding: 0;
          font-family:
              system-ui,
              -apple-system,
              BlinkMacSystemFont,
              "Segoe UI",
              Roboto,
              Oxygen,
              Ubuntu,
              Cantarell,
              "Open Sans",
              "Helvetica Neue",
              sans-serif;
          background-color: #ffffff;
          color: #0f172a;
      }

      body {
          padding: 1em;
          -webkit-box-sizing: border-box;
          -moz-box-sizing: border-box;
          box-sizing: border-box;
          width: 100%;
          max-width: 1280px;
          margin: 0 auto;
      }

      header {
          text-align: center;
      }

      h1 {
          font-size: 2.5em;
      }

      a {
          color: #f47825;
      }

      @media screen and (max-width: 512px) {
          h1 {
              font-size: 2em;
          }
      }

      @media screen and (prefers-color-scheme: dark) {
          html,
          body {
              background-color: #14181f;
              color: #f2f2f2;
          }
      }
      </style>
      <style>html {
          height: 100%;
      }

      body {
          display: table;
          -webkit-box-sizing: border-box;
          -moz-box-sizing: border-box;
          box-sizing: border-box;
          width: 100%;
          height: 100%;
      }

      .error-container {
          display: table-cell;
          vertical-align: middle;
          text-align: center;
      }

      .error-code {
          display: block;
          font-size: 4em;
      }

      .error-message {
          display: block;
      }
      </style>
                 </head>
                 <body>
                     <main class="error-container">
            <h1>
                <span class="error-code">404</span>
                <span class="error-message">Not Found</span>
            </h1>
            <p class="error-description">The requested resource wasn't found. Double-check the URL if entered manually.</p>
        </main>
                 </body>
             </html>
    HTML

    begin
      pid = spawn bin/"ferron", "-c", testpath/"ferron.yaml"
      sleep 3
      assert_match expected_output, shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end