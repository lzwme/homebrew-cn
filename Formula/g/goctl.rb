class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://ghproxy.com/https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.6.0.tar.gz"
  sha256 "69bd7ede2c65d3da66929220d9a2c44979732c383bfc064182250c48f3c27b7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecc917df3cf38070b2244e24bfc8add8ba311d95280bb0a8e1eb0f4610bfd85d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4689960179d8c17768ce82af409ca1e469ad14aacf62961b56579f8b8b4152db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "822a4c3892ca4e92fc2e5e843f6f9c09eb7ef3ea603c6c2408b4be824b2e104e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2effa8f485f71340838e396c6a17874376fe2027b75f52d651cdbefd4a1a6e8"
    sha256 cellar: :any_skip_relocation, ventura:        "3875451331d2804b17a618a7fb94b50450c82679225737b170624435b1730f6a"
    sha256 cellar: :any_skip_relocation, monterey:       "f08682aa2f5fd06e37f5700d174aab0e1f6137680410e32c45f7033c281ae767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25324bd07b079fb408725f3d3e482d06b972d5ebb8b5bdecf22ea1e2a22fb945"
  end

  depends_on "go" => :build

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "goctl.go"
    end

    generate_completions_from_executable(bin/"goctl", "completion")
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}/goctl --version")
    # configure project path
    %w[api model rpc docker kube mongo newapi gateway].each do |f|
      mkdir_p testpath/"#{version}/#{f}"
    end
    system bin/"goctl", "template", "init", "--home=#{testpath}"
    assert_predicate testpath/"api/main.tpl", :exist?, "goctl install fail"
  end
end