class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://ghproxy.com/https://github.com/zricethezav/gitleaks/archive/refs/tags/v8.18.1.tar.gz"
  sha256 "8901854f09ebf18029e650afb7d908d8e58f13c80d34c01d83d8362944237dcb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dade54700cf4e0cb82ccf009e5dfc3bbd2dbef6b16da3a6c45173c23ab0f0bfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00aa64adfaa65f23469a7272d37f151a92193acdcd3d51a3cd437d04323aa73d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0156bde75d425860364026dd2cbfde689bd608d57347b43fed95bbfd8ff885e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "6953077d2dc42d571ecad769d4531176c19ea7efc1d0641611640546c0c34b3d"
    sha256 cellar: :any_skip_relocation, ventura:        "85bf3dfc8db564648b393def0de779688dde26d571905295ce05642682826025"
    sha256 cellar: :any_skip_relocation, monterey:       "de268c3c2410d8fa5db43a7f6109580c457ae00d2eb3e6eb4599d80554976150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e907be45bf5bef2de0e21c82ce5688bf7c6e02c932baa3f19c85fbe6c4bfadb2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"gitleaks", "completion")
  end

  test do
    (testpath/"README").write "ghp_deadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    system "git", "init"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match(/WRN\S* leaks found: [1-9]/, shell_output("#{bin}/gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}/gitleaks version").strip
  end
end