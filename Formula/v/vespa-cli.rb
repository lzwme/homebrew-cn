class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.265.12.tar.gz"
  sha256 "caba32e2c2986151abdd77f9e16863d069c9d906a9cd50499f03bbc4867bbb28"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90448d5109210219062698860d0e27d2619f9447013f8943813c521174d3467d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7df2f8ead37bc70c3950fad33738e06b5eae1f1c9a2e7a768121bd68a5a21d9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3864131c179b625e7ea3f04da36c5446216a7d4cb21ceabba8df625e99debb29"
    sha256 cellar: :any_skip_relocation, sonoma:         "36af7658c5aab7f673cdb4354f410bcdc3f8442b9a40a768cc7dd9f4739533a0"
    sha256 cellar: :any_skip_relocation, ventura:        "661773297cd4e02aa7cf7a490dd836cab90bcbc681924af0b710dd6835c1a1b7"
    sha256 cellar: :any_skip_relocation, monterey:       "a22a3cbcfdf0b5e73fc18fe24a35fc860e14fcf84128be602a3cc9c1da33941a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea8f9c822de59583b8ae0299f02a032a42d337908ef362c39f51556a3d8c4d69"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end