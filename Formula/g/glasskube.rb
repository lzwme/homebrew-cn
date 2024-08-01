class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.15.0.tar.gz"
  sha256 "71ffdbfeaf5a751065abc7a8233eb2398fbf10e801294be7c64c2a93b5eb25e7"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aad97b9e0e5313683becdf9d04147e20c2d2e2613fd1eea984b89cd66c8037e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81aa56295e7db4518b46e6bf4423a5f7398401e846d7b78baf8c72b46f603d28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2828ad81d4a260557dde812755e2cc5068ab604094520f16f21d27b3b8ae4ccf"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f610eae005b9f5bdc6b6d23075fe4ccf4b800bf2ce46def4c35806230b5a9b8"
    sha256 cellar: :any_skip_relocation, ventura:        "fec80e149c03565443c0b4bb6a0312883929cd9e84536050ccf715c3c50a9148"
    sha256 cellar: :any_skip_relocation, monterey:       "f2ce30d23c3bfe5416fcab2febab477665c365da968d6b4371c0a75b0b429bc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a4a78e0be90c494d86d6d5c59a996daf6d7f0ac97f2095ac26776183aa11e99"
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