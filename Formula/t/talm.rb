class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://ghfast.top/https://github.com/cozystack/talm/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "7f0c2761d75167eca86a1a637d68cd3f0487658334361724df1e12396e085d54"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d57ccc3439a32f3c554f2506b84bd92565b4984e6a9f6aa87bc81e1973593518"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5165acf3000ed70ffbceaad6cd52c777088059cbd68df9d3e5b0b6803fd4134"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e9bf74e261235919039d0e42705c3657c98d4c300df5df1eda270648ca80f3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ed1b16a12d83da84aa08f01755348eed61aae2e1efbd63e9bbfc0ec60ad401b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cf34aa6781527a6222735cecbd57eb5af9d044477bd450d7cf46d2831323802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "305d6859db2063fb7a0b205a5883e37a8bc4fa2bdc143863c0378fca7be110f0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--name", "brew", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end