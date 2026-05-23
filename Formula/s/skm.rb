class Skm < Formula
  desc "Simple and powerful SSH keys manager"
  homepage "https://timothyye.github.io/skm"
  url "https://ghfast.top/https://github.com/TimothyYe/skm/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "5ed6c41b5684ddecbd2aa166d470d7355a37dced3f6afcb0537e5acd5cdce6ae"
  license "MIT"
  head "https://github.com/TimothyYe/skm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfe5495f525bc4092c3f77d30e2c16c55a05d146221b84cb85497725752928df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfe5495f525bc4092c3f77d30e2c16c55a05d146221b84cb85497725752928df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfe5495f525bc4092c3f77d30e2c16c55a05d146221b84cb85497725752928df"
    sha256 cellar: :any_skip_relocation, sonoma:        "df73779f20013ab62f2f7e952f54df11fb34d4826fc32906a3445df7a4f8149b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab8b6b74dbea969e748ba9451174dd372eac187ef6d25fa2978f01c69bdf2fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb6b4236301e346c9f28dc34646a16863b721e26e545d482abbad7fc8ecbefeb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/skm"
    bash_completion.install "completions/skm.bash"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skm --version")

    store = testpath/"store"
    ssh = testpath/"ssh"
    ssh.mkpath
    output = shell_output("#{bin}/skm --store-path #{store} --ssh-path #{ssh} init")
    assert_match "SSH key store initialized", output
    assert_predicate store, :directory?
  end
end