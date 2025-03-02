class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https:go-zero.dev"
  url "https:github.comzeromicrogo-zeroarchiverefstagstoolsgoctlv1.8.1.tar.gz"
  sha256 "16e7e90c95e702da6d9e102a95a07dcca7c5e7bd08351c8e56b6fe40fea9a27d"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{^toolsgoctlv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4a634df1bebe37d45ff610fd7850f7eb53639fa9075c8e55dbf72ac6b0dc61c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53675271b5557215983282882014aff19ac97dba8e622c7853b5d70c5064fad3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1399504e2697007e3333862d6c96af3d10ce17cf144c415be55a9b7ac77d5f40"
    sha256 cellar: :any_skip_relocation, sonoma:        "420a952431aa7e0b5a51655a92d3d192c00c0cbe479733cdd446b3c42a6aae54"
    sha256 cellar: :any_skip_relocation, ventura:       "4a81e161e965e3ad30bcccfeb492dc533a94338e97f3723cfd9c07fd078126a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "226e9cae20a67253ae24af177f64d63e3622a4fbec79c78a40ef0ad514b1d92c"
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
    assert_path_exists testpath"apimain.tpl", "goctl install fail"
  end
end