class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv1.9.4.tar.gz"
  sha256 "ca315ae50e00c6a02e3b36f29115d4eeb71bc8f73126da3de7b73b2b21f2effa"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d674657c3ef1e11e01524db480ba70d872667829264c088a7bdebfed82402068"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82841f37f40fd8d5481fee9a3ab94b7f1fe1987e9a60171f6ca136cda2aaee38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16261c2117e50f3abd90e2e6534a4a2cb94ec5be0d79235e8794518b7d26cf69"
    sha256 cellar: :any_skip_relocation, sonoma:         "794232ebabd72ab1de68d170d555d3036fa22eb28d1206e94c1e51bd96620559"
    sha256 cellar: :any_skip_relocation, ventura:        "7418308e1bac513870bbfb30a33ff1622e26609e2e88c60a9e7bf3d5c09ecf70"
    sha256 cellar: :any_skip_relocation, monterey:       "c03291c5a2bedeb850c2d146e6bc519541fc58f6c7917873aad8d3ffd0580cc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94da36c4b0f29955023b07ed7d552f6869a1f8c5c6dad55b6b70fb3e5b74602b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdtenv"

    generate_completions_from_executable(bin"tenv", "completion")
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}tenv --version")
  end
end