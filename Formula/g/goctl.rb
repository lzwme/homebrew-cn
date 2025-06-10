class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https:go-zero.dev"
  url "https:github.comzeromicrogo-zeroarchiverefstagstoolsgoctlv1.8.4.tar.gz"
  sha256 "8760cdcbbca3af762e441ea0ad9ed40858e9e6209e3c6747274914b0d9b41be7"
  license "MIT"
  head "https:github.comzeromicrogo-zero.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^toolsgoctlv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b7bd45cf22a249cf0ec3eafa0ddecc3ada3d085faa0c6af431e78450c9b18be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65b344f8dc0c30e1201155b3a11bdba50d61968b9e0fb1d7bce0ce6c6530f0db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cc383d2c001c47787ad9a96f9a544fc802b02284a35c428f3567c812de022b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "53e2098ca90f1999c83d790b3d82180c379bebd34228012189e8eb02610052cc"
    sha256 cellar: :any_skip_relocation, ventura:       "77820d8d74d9fe46452862e29fa9c8d06dad87be7ec2d6eb69d98f3a210c61aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "539705f937bfdc0aff8d59c512f1ef3df19c8deb621301deac040630a5016451"
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