class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https:go-zero.dev"
  url "https:github.comzeromicrogo-zeroarchiverefstagstoolsgoctlv1.6.6.tar.gz"
  sha256 "30a61361b442282bc0f2eda7922c139bc1ecf267a077edb219cd4bccda6524ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ff7f0ccb6ce4139d3d313dcc5583edfb17f437e57a06bbbbf41aecc4123a484"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3aacb67ebb74852141bf5520518818075fcabfee3250fda7914f51780ca2a936"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c856e386f3988a63f86dabcce99cf6aa9b24dd2e193728c829902dd635cdb1a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "834725c1d093c849852ef3a0a470a2d7aa2c8a5d176699d29de142bfbf95f18d"
    sha256 cellar: :any_skip_relocation, ventura:        "61db7787885f0e7ffab4ca2bcaaa480c7d2aa7e6289204f538a5af5b56340a67"
    sha256 cellar: :any_skip_relocation, monterey:       "a3e7d510c4188da7313ea0e13d987962c7185079988ff9dcbe0b3339b1838a60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dec21f4b52ddebd61a69fb30846534d5dad860abb55dc1403ef1636b7472b8af"
  end

  depends_on "go" => :build

  def install
    chdir "toolsgoctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "goctl.go"
    end

    generate_completions_from_executable(bin"goctl", "completion")
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}goctl --version")
    # configure project path
    %w[api model rpc docker kube mongo newapi gateway].each do |f|
      mkdir_p testpath"#{version}#{f}"
    end
    system bin"goctl", "template", "init", "--home=#{testpath}"
    assert_predicate testpath"apimain.tpl", :exist?, "goctl install fail"
  end
end