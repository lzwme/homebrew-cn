class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.287.20.tar.gz"
  sha256 "81fca62c64e7af85bf0b9f8644590f940f49a88f6a8b227638fef8a4020fc253"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aaaa651f25717dd70fffbcfecf6f720768a1bb0e2072392f269b31aa789a622e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "283e22828a34a53baca79d98d5ecf38bf1ce1a3d8e47a3b476386bc5f229c22b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f90b3fc8091e6c8a99bb1b63b067a4e61d83a96541cdf17ff1ca5066ccc58e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "3216e2101b3b5136b4ef7a32db17b72ffd67a8cee361b9a6d6916499bb5586d8"
    sha256 cellar: :any_skip_relocation, ventura:        "b57bc4d2ae04cc9723e2d840cb4bbe1ee93c5b9dc162a99a06ebdbf62c982709"
    sha256 cellar: :any_skip_relocation, monterey:       "00a6a2d287f07d20eb92473cb86bf58807d1d2a3c5b44e74a58a97e8f1202d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cf7d2467fe087e37f43ac3317b9be412751246ca5af9aa8a8a742f8e456b213"
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
    system "#{bin}vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}vespa config get target")
  end
end