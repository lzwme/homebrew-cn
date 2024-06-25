class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.10.1.tar.gz"
  sha256 "f177e0237b0a6f35ec088282c2ad8f1a085e57d380f1644e2dbda6c3e7130043"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6614a0d463e442a85cdbc9c7d97d4d779998516045329abbd6265b97d2d4082"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae99c2a5ed7d09e8a162a825153001dfc3e30458a7e75078d445296a0b5e1627"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "896f0b5aac63695da583064f820456cd02c5ab5df0c599572dd8fa8e1a09678e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f9c4ede84fc021a4699c8f9d78b653e4ce55258e4c36f7b989373e33d0cf88f"
    sha256 cellar: :any_skip_relocation, ventura:        "2cf25e86408d97f582479f780b927662d261821cbf99ac124a5931bf20cf0eca"
    sha256 cellar: :any_skip_relocation, monterey:       "cb1f36199ced710e60330bd7fb1d907ea2d252c2e832b376b911cd73e3fad32c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1dcd3f4a350574cefef8a3f5f0f4644925d344306c33b3071557f1a7bb1f968"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comglasskubeglasskubeinternalconfig.Version=#{version}
      -X github.comglasskubeglasskubeinternalconfig.Commit=#{tap.user}
      -X github.comglasskubeglasskubeinternalconfig.Date=#{time.iso8601}
    ]

    system "make", "web"
    system "go", "build", *std_go_args(ldflags:), ".cmdglasskube"

    generate_completions_from_executable(bin"glasskube", "completion")
  end

  test do
    output = shell_output("#{bin}glasskube bootstrap --type slim 2>&1", 1)
    assert_match "Your kubeconfig file is either empty or missing!", output

    assert_match version.to_s, shell_output("#{bin}glasskube --version")
  end
end