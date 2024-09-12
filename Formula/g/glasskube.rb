class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.21.0.tar.gz"
  sha256 "6eb54f51a1c3a44803bdfb5f69d62f874ce5b5fcca8c92e57425ec0c7da2f8f1"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6d25fcd675a443ee9814532f6f36f54018a70cdd6d828703cf0e9e7444e22c9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d25fcd675a443ee9814532f6f36f54018a70cdd6d828703cf0e9e7444e22c9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d25fcd675a443ee9814532f6f36f54018a70cdd6d828703cf0e9e7444e22c9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d25fcd675a443ee9814532f6f36f54018a70cdd6d828703cf0e9e7444e22c9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7068c78c8da1db8a8d8426511253536301e7d90df0a835289052e6dd2bdaf5c3"
    sha256 cellar: :any_skip_relocation, ventura:        "7068c78c8da1db8a8d8426511253536301e7d90df0a835289052e6dd2bdaf5c3"
    sha256 cellar: :any_skip_relocation, monterey:       "7068c78c8da1db8a8d8426511253536301e7d90df0a835289052e6dd2bdaf5c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d44bca9ed076ce87c2b4c6fda05bfafb9bc4ed6e5026de96a555b8c66b824592"
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