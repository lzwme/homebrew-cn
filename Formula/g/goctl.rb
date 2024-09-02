class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https:go-zero.dev"
  url "https:github.comzeromicrogo-zeroarchiverefstagstoolsgoctlv1.7.1.tar.gz"
  sha256 "71e24a955f504a8428f788369ae4950ce16cc155fad767cebd674a8cb07c1f15"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbbfbcd906b148f9366520ab32ad8c1c09b761befd7f4d5ca61a9973785a1c5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbbfbcd906b148f9366520ab32ad8c1c09b761befd7f4d5ca61a9973785a1c5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbbfbcd906b148f9366520ab32ad8c1c09b761befd7f4d5ca61a9973785a1c5c"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc8805bea3c7f07d818ebe2b94bd79dd25dc43cab18c19aab3332b8b83e8c170"
    sha256 cellar: :any_skip_relocation, ventura:        "dc8805bea3c7f07d818ebe2b94bd79dd25dc43cab18c19aab3332b8b83e8c170"
    sha256 cellar: :any_skip_relocation, monterey:       "dc8805bea3c7f07d818ebe2b94bd79dd25dc43cab18c19aab3332b8b83e8c170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12d54e825ae3accde8ae83e2204bf6b29124322e0e14905f9120abc69dba3ab6"
  end

  depends_on "go" => :build

  # bump to use go1.23, upstream patch PR, https:github.comzeromicrogo-zeropull4279
  patch do
    url "https:github.comzeromicrogo-zerocommit19c5fc3c29335df2f452d0947b6740337abb94ce.patch?full_index=1"
    sha256 "0cc51959505721b4978d90f2990c93dfb3c00dda2ffbb8416c589c277e3971fb"
  end

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