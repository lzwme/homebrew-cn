class Timoni < Formula
  desc "Package manager for Kubernetes, powered by CUE and inspired by Helm"
  homepage "https://timoni.sh/"
  url "https://ghfast.top/https://github.com/stefanprodan/timoni/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "357a971802cc518ed15f6fb5771c69b7f9c4569e8154f67562eb2e4c9c7e0993"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/timoni.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5172a8b74de0adb5eb40ef940ac466fba862fae1d30662f6acd8852b79d0ed5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6421266609cb9b0bd8514fe992780a986fc4b03921db92fea874fb724893abd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f959bfb6bcba7dfdc61a7cca33882eb6a3821598d8824f204f43d733c6c6864"
    sha256 cellar: :any_skip_relocation, sonoma:        "66884b1149a4ec483acce392bd22a3100b141962775774d1560d5c6a89cddf31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ee038834dbde1943f910eff65d7ee1dd0a1646288783d9b2c2616f78e421dbf"
    sha256 cellar: :any,                 x86_64_linux:  "8311fa0a4073e12d3f3ad40c9e06f021b9c263a6a12957d1d60c2c6e00a77199"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.VERSION=#{version}"), "./cmd/timoni"

    generate_completions_from_executable(bin/"timoni", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/timoni version")

    system bin/"timoni", "mod", "init", "test-mod", "--namespace", "test"
    assert_path_exists testpath/"test-mod/timoni.cue"
    assert_path_exists testpath/"test-mod/values.cue"

    output = shell_output("#{bin}/timoni mod vet test-mod 2>&1")
    assert_match "INF timoni.sh/test-mod valid module", output
  end
end