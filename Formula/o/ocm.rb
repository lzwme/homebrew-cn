class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://ghproxy.com/https://github.com/openshift-online/ocm-cli/archive/refs/tags/v0.1.69.tar.gz"
  sha256 "17dc257b9cc2544acff9420057b1c62fc9895ccc59ff87f4bc4215603508a5cb"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5841a6ab93234d49fd26845bff0a7a24718434cb9f82881c8a4ddca1720e4d30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0f70b8841df06e396aa06e94c5c3e175466b915ab1dfc68965cf7d585bd4173"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23459ac7686609eebb45c6d96f8611276259a9803b63315a3e640e3ae8eb53cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "260ec9052f9833b6fd296b8c8198344187360c4f5c4ce60bdb308363986e4da8"
    sha256 cellar: :any_skip_relocation, ventura:        "806ffe972f839227c3492dea70ba17978585e339756d790324264da122142ba6"
    sha256 cellar: :any_skip_relocation, monterey:       "93f85566c88e9b65e8e213530beb1ecf3fe2fff21d53166ec62638051100e8c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c66884814bf9b1b1875a680f6c324855dacbd2065461fcdd158550e4fe884dd9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/ocm"
    generate_completions_from_executable(bin/"ocm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocm version")

    # Test that the config can be created and configuration set in it
    ENV["OCM_CONFIG"] = testpath/"ocm.json"
    system bin/"ocm", "config", "set", "pager", "less"
    config_json = JSON.parse(File.read(ENV["OCM_CONFIG"]))
    assert_equal "less", config_json["pager"]
  end
end