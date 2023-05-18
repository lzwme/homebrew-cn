class SkaffoldAT139 < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.39.10",
      revision: "ddbda1623f724acb61b38b499fd75adb5089634b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.39(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae507c1bce3c9f40676ac9935534af5add15a8bdf61e86d2a8d6aec5e2fe0062"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ea401edf133c71a2b8302b3f0dd77aea6c58d6974f8457f7b3321cc1cee5133"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16b025870c27a5da25b3c35c9ea4a1153ec18a2c0543f0395bfedc522df3cd42"
    sha256 cellar: :any_skip_relocation, ventura:        "dd6a763f6c47715153d3bbaf13aa073a442f079a0920055e9f703e207ed795e2"
    sha256 cellar: :any_skip_relocation, monterey:       "50dda565c49e9383ba15f2ece23694912ad846ed2fa9c61b8ce94983200e3dc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "eabc7a405afc7cc8f39d0caabbfc60e234a8bfeb55a0501aa736e7db3ab22f25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffd4a621b8ce1eb238344937550efeaa498fc744b19f21b33a25fded328a5370"
  end

  keg_only :versioned_formula

  # https://cloud.google.com/deploy/docs/using-skaffold/select-skaffold#skaffold_version_deprecation_and_maintenance_policy
  disable! date: "2023-10-18", because: :deprecated_upstream

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion", shells: [:bash, :zsh])
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end