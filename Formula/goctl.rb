class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://ghproxy.com/https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.4.4.tar.gz"
  sha256 "f14f6f45ad11e98262460656d13c43b13ec3ec9c4bc185a739c1fc584f55a677"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ff2e65c32579894be8b0ed1cd69afa272541309f826e1a25969c6df05804194"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fae505dda6d542a153c26c97305cadf6a30ee6026f16f9cc2da5c44749103ef5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69dcbe17bd0c79c7f4987cbaf8a7a807ed4ae04d5b65605b7ba3b03682808992"
    sha256 cellar: :any_skip_relocation, ventura:        "3dc35f63b901a39e84526224bd5d5d1b9f5ad573c10b1ad4cd9b10b6524bae28"
    sha256 cellar: :any_skip_relocation, monterey:       "97c4b63da81a3d6185a02f8287f356ca132efaf8e38722b8fadd935bd54af714"
    sha256 cellar: :any_skip_relocation, big_sur:        "8eb1bcb4c9af2649830b51b8e3cf14876f3b8814578fee0ee6a77b996a23951d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2731d2aff0689bdc5e1c26bfeb1eedf09687fb081f70524b899c85f6ca76095"
  end

  depends_on "go" => :build

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"goctl"), "goctl.go"
    end

    generate_completions_from_executable(bin/"goctl", "completion")
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}/goctl --version")
    system bin/"goctl", "template", "init", "--home=#{testpath}/goctl-tpl-#{version}"
    assert_predicate testpath/"goctl-tpl-#{version}", :exist?, "goctl install fail"
  end
end