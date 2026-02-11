class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.639.59.tar.gz"
  sha256 "0b66a87ab317b68e91878f64df93bcaa43a3d57a1cb29c46274db20ff4651bd1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14d02332feb620100739648eeab128ab05f237e2f324944f77412b7836a2752c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff4f6981c02687ab864e7833f6d0e598c063d8159afbbc9891e71a061a88ebfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b83907af8869155f6378344c66994ed764b9417ac4282dcd8dd406efb6849cde"
    sha256 cellar: :any_skip_relocation, sonoma:        "a203ad014d3d00e80e0e5886cb19c5e414efea93c9b15e6f834eb1fb75884466"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d2e1bc43f1c76bda9b75b4be8d5788ae8902f816fb551fdebf32eab07874908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10f88b792d2fb2a07d52c62b999365db8ff879892f2f5cb2bea0611a886d638c"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", shell_parameter_format: :cobra)
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end