class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.2.0.tar.gz"
  sha256 "da053bdfc58b0aae778ee64de61ea45897cabde50d4c2556fd12f85fdf91e11b"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15f0034432c90fd81fc358d410fad828f360455a38b74acd8a67bcb81e3a41fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e62b17678ff816e99ad50ceb4ae880b84c829fa36c862628004bf7fcb2fe4d16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d0de5741f5c7951ccd14493533ee562bb9b4e8587b6b73d09bce3c91a76965f"
    sha256 cellar: :any_skip_relocation, sonoma:         "203926f178483fc31104c79e12077fe869db557d20ae1ca789a5d30c838e430f"
    sha256 cellar: :any_skip_relocation, ventura:        "4c865556534dfc042c40d46c253ae8770dea6f6549466fbd3508c14e99039570"
    sha256 cellar: :any_skip_relocation, monterey:       "3321fa4397ad1a1ba304210858494a4f07e66da9f19e4365dbf63c77aebff843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "927e4755ef14a7e0297e8456ad1ebcb1c0b5d0a6b3e721593be04759fdb6d51b"
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