class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https:github.comproject-copaceticcopacetic"
  url "https:github.comproject-copaceticcopaceticarchiverefstagsv0.5.1.tar.gz"
  sha256 "d695f29beb71d733b76c9c81145b6e1661ab506ac2a34043c4423860690af3fa"
  license "Apache-2.0"
  head "https:github.comproject-copaceticcopacetic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3b64604e0aa4be93a2dd08f805151c6a2d42fc7a0b5398f42c895766a71d303"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79dfa53b32462f6e0120df5b67e59fe86309645bced06cb95499404a1a0036f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f32448d676467690ec5e86f3282b1fde50294953f7a602f2e4dde67d4e73e09d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c6ca3712e0504fe006ac1924fcccd49ec8ba0a0938e866d1812c8f5028b5a19"
    sha256 cellar: :any_skip_relocation, ventura:        "6e5616470ba4c1796f5549d0f19c67de185b02acdd8ea5e2ecbaf5ebc15fd859"
    sha256 cellar: :any_skip_relocation, monterey:       "fc2b2c873acdc2a2b964d249860568bbc5c390b6408514f8c5c754ad5706d3b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cafa3a9552bff9a6f9b94378d06c321df564d9824273c99a4078903dd7795d9c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comproject-copaceticcopaceticpkgversion.GitVersion=#{version}
      -X github.comproject-copaceticcopaceticpkgversion.GitCommit=#{tap.user}
      -X github.comproject-copaceticcopaceticpkgversion.BuildDate=#{time.iso8601}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match "Project Copacetic: container patching tool", shell_output("#{bin}copa help")
    (testpath"report.json").write <<~EOS
      {
        "SchemaVersion": 2,
        "ArtifactName": "nginx:1.21.6",
        "ArtifactType": "container_image"
      }
    EOS
    output = shell_output("#{bin}copa patch --image=mcr.microsoft.comossnginxnginx:1.21.6  \
                          --report=report.json 2>&1", 1)
    assert_match "Error: no scanning results for os-pkgs found", output

    assert_match version.to_s, shell_output("#{bin}copa --version")
  end
end