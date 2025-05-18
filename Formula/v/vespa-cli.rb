class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.520.18.tar.gz"
  sha256 "13307228604423c42f4091f160107cca71f0d2cc108a6bb19854b9420a293318"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "598a3df05a92f186f5ddc24d30be38fb70f5f2e6ba2ab501f56ad8438cd65c7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d8e3ef695879260f72697ac3947dea51f8bf0fbee7ab877e6b80b5c84de5458"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ce1fb422450db8c790abfed365e7cf91c4fbf455b98123809750fe780a1f0c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "75860e11ab9f9c91ac01251f6c557b9dcfc5fa35dd052249b5bf163e3eb97546"
    sha256 cellar: :any_skip_relocation, ventura:       "ea4cf0e338110c7699c4551e7f1313bed68931b8eccd9c1d48685ff6e80076ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2773c128e7d2cd1b4047d41ec4ef9eaadf768a810a3e896d13fa7a5624b55252"
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