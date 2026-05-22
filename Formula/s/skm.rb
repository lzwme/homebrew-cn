class Skm < Formula
  desc "Simple and powerful SSH keys manager"
  homepage "https://timothyye.github.io/skm"
  url "https://ghfast.top/https://github.com/TimothyYe/skm/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "8cce691afcdf98ad084c9dc6a2460f250ec2b84a1f7baa847181050ed5fbbcbb"
  license "MIT"
  head "https://github.com/TimothyYe/skm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd2a01ad0aed23f1e23dffc0c166884a54afcd2eb2a08872fbd3afb54aa50c46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd2a01ad0aed23f1e23dffc0c166884a54afcd2eb2a08872fbd3afb54aa50c46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd2a01ad0aed23f1e23dffc0c166884a54afcd2eb2a08872fbd3afb54aa50c46"
    sha256 cellar: :any_skip_relocation, sonoma:        "d729d62e710fbf3688d966e27587240c063b5207ad741d0217f87676d4f03351"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79567acc4c1fb61fd697a011760880536af83a613faa3cedecc7fd02501bba6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b751840d2d1909565a0be76f13c78a305ef6e8968199464c7d0e8ec2654dd927"
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