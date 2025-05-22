class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https:sql-page.com"
  url "https:github.comsqlpageSQLpagearchiverefstagsv0.35.0.tar.gz"
  sha256 "9cc73f5abc33727e646022469505f969f97b16e172a456caebaba531b5595ee7"
  license "MIT"
  head "https:github.comsqlpageSQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a092de09623d588b4a96b5bbec2badfea14395ddf7bf7dc3425ab847c824051e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16935fc966bf6f2b32a9e3914c174a2f8c35e7423f456b1c50b1b471bb912c95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ea23bdaa182584a0643849878bd4e84f84944de814c1ff6a5d2f6ef244655ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "34a9f613a35afce6632c53237a1d23f1bb23afb113f682f9096cec471b3df01c"
    sha256 cellar: :any_skip_relocation, ventura:       "bd90ba71b96bec649fa7924d50a8f59c9068f37fc7f6214548ee2ba9b0f6175e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5425332b3c6e3648e1a0bacce6a4b7c3b5a594b24532ae5e0ed91a5ebfe26142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d3e577227d1b7019d660d46a033eabfb8f75a93e3a1fab72dcab4052b4ae86b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = fork do
      ENV["PORT"] = port.to_s
      exec "sqlpage"
    end
    sleep(2)
    assert_match "It works", shell_output("curl -s http:localhost:#{port}")
    Process.kill(9, pid)
  end
end