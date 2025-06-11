class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https:aquaproj.github.io"
  url "https:github.comaquaprojaquaarchiverefstagsv2.53.1.tar.gz"
  sha256 "cb86d77f442a88844696c773364205a99cc543ecbbb1790540fac494b06218f5"
  license "MIT"
  head "https:github.comaquaprojaqua.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "255ac172ad237a60fa8319d1a9452f3aeba4226e2d404e4b72ba9f47950c6340"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "255ac172ad237a60fa8319d1a9452f3aeba4226e2d404e4b72ba9f47950c6340"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "255ac172ad237a60fa8319d1a9452f3aeba4226e2d404e4b72ba9f47950c6340"
    sha256 cellar: :any_skip_relocation, sonoma:        "51551f70cfdb92e1d31176a02c70dadd402c702abb5cb43d91cc48b5f5b8c871"
    sha256 cellar: :any_skip_relocation, ventura:       "51551f70cfdb92e1d31176a02c70dadd402c702abb5cb43d91cc48b5f5b8c871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b938cd075ce3a87bad5868f0e0ae3500afa66fc3741289564f99de4f8389f267"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdaqua"

    generate_completions_from_executable(bin"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}aqua --version")

    system bin"aqua", "init"
    assert_match "depName=aquaprojaqua-registry", (testpath"aqua.yaml").read
  end
end