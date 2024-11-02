class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https:sql.ophir.dev"
  url "https:github.comlovasoaSQLpagearchiverefstagsv0.30.1.tar.gz"
  sha256 "f91f3798614c27146979d6b1127a7a1f24707d63720665bd37aff66ad5e22b36"
  license "MIT"
  head "https:github.comlovasoaSQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29ebde56d3e50773d9d75589bafbf4c66cf849f8c04249abf36041eac9e4f535"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "469b5500fa326d9310de22d895f9af4b437df8cbbc565d83efc6157d0f2a2109"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57503e66ebe5cdb17ff1da6975297f1aa9908dcbfbf622413116049d81ec48c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e1971ce65f663cd963453d3e7ded079e01914d828fa527d57ff30b8ed32940f"
    sha256 cellar: :any_skip_relocation, ventura:       "a77d0b17e4fe5e94535ce71f2c7fee1027403720dca5ca36277afd7c4727462f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63e431755a67019ab3944228a37ca069e4eea322287218e88eafeb758add3956"
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