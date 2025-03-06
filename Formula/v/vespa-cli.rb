class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.491.19.tar.gz"
  sha256 "c14de6dc255dced2dbc52d2d5570db76c2348c3045b0be1c92136277e4915f6a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "005ef2d70abce6ebfadab12af52bde4989ed6545f391c2fa23707881e5b42694"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05be0da7369783b821305a6f8de2920f3ee31120ffb556ac716864bd96410b96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3df085cc476b672b6ba3854f36a3141b088c6226f6a23b03d94ee588fc206ba2"
    sha256 cellar: :any_skip_relocation, sonoma:        "98980cc29ab0cd140075612b8621e0f6940358f091851770e404f774a9a5e40b"
    sha256 cellar: :any_skip_relocation, ventura:       "bc08d1ce8b6532504250cdf14abc01b058ab8a81794653502ad11f60e1ef9742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b81f9f0057715c9fb019d1d909d43f7d574e3bb49e7ef8374aa22d133346da10"
  end

  depends_on "go" => :build

  def install
    cd "clientgo" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system bin"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}vespa config get target")
  end
end