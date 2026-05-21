class Skm < Formula
  desc "Simple and powerful SSH keys manager"
  homepage "https://timothyye.github.io/skm"
  url "https://ghfast.top/https://github.com/TimothyYe/skm/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "81a4646a244b9ecfb3284be610696df33fd5afd5a25853c83a5902ba92af0478"
  license "MIT"
  head "https://github.com/TimothyYe/skm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eda1398e141d611ec3f8968fcc953b0e769febfcbfb7c01382d80e15e21a78ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eda1398e141d611ec3f8968fcc953b0e769febfcbfb7c01382d80e15e21a78ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eda1398e141d611ec3f8968fcc953b0e769febfcbfb7c01382d80e15e21a78ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "e53df41067a07fddb090205fca3f15e0f544294e1bdc25eb2325467d027cf1ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2934c8baec909f6bc0c3f601150277b0ff74c6b4f6b16f7ed3db92ff4fc2a7bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b95a9086f721a20cfa9961a38010fa397bdd8566ba25a65ca8cae796094fda1e"
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