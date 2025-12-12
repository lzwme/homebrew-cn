class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://ghfast.top/https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.48.0.tar.gz"
  sha256 "65567cfb171d778320bfd7be77c7e9d716d4fa65ca6d528eb617767335876864"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8ee7553ca52addc6b13e3f90f6be87474a1eb337d6aa484dc799074be862761"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca54b24d77321fedd273c0cd86666c77e1a6f7edd88d12776f834d8615b3d855"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51b0c9cdef6823dca98ca309596b0794814dd10e5959e8d27adcfc91699cfce4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b1652fb808984a8be7c4db4c36be4c46b11a9415025b2f955bfe2ab799923cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f0dd3fb9a6f31b55caf3b1e0b6e867fa8d76ab05fca58e6d9528538e9ab3572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fc2b9be8a021232c94e8fab71f8b5e422690b4715465261e0156add86a67219"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output("#{bin}/scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end