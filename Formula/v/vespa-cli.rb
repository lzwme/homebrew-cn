class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.371.16.tar.gz"
  sha256 "be8322777eaab8b8499854210deb7d8c8ab88af1c0ac7aef00584d681b23abf3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1c3af3646a5f7359ac090803da00df570e3d010fb64a63aa6d3554ffba14103"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97c782ad6ce3951649342c94af8bd603fb7a4a171ee8054fb6cde29fd1e05d96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fde33ab756a826d4f80f9941826c5f78d2d642d6afd59962ce3087d0f993f79"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d2e9e8e298434532e71e198c17a5dec675c586bb81b75c2bba87f79b72fe34b"
    sha256 cellar: :any_skip_relocation, ventura:        "958f41a829d49bfd8a39080941cd2b5b6f42f6fc4c459be12c5bf6bb343d32d7"
    sha256 cellar: :any_skip_relocation, monterey:       "0d43886d8e80e02da413860f0415c5a72c61d80ea7f571139cdc35b8ad22384e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c78c21433f8e0a951558ada0244fba7878c6e00088c6745e7eb32d244a2c0d99"
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