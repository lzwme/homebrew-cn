class Leetgo < Formula
  desc "CLI tool for LeetCode"
  homepage "https://github.com/j178/leetgo"
  url "https://ghfast.top/https://github.com/j178/leetgo/archive/refs/tags/v1.4.14.tar.gz"
  sha256 "09fd101c71b8eb7c7b26d5815925be00eb1d228d00c1e67759585e4fed26ca82"
  license "MIT"
  head "https://github.com/j178/leetgo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "831132b6b0456b336940c9dcd24cb407e622980d98ca9f61d59dae27bf8982ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c91f4abbd99dfe597af2fd911b9984b8a12541f084615d9bfafc13ddd3090c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "805be64a0a8871d337b7f40b0be0b2f1060cfd2eb2df3df1a3e7a5891a011739"
    sha256 cellar: :any_skip_relocation, sonoma:        "cce6a910e029733e9ede40ce5899b3b532d079444f1bcadadfea553597ce4e1c"
    sha256 cellar: :any_skip_relocation, ventura:       "03ec177879c2983595b051035a2ada17985df47eac21f13fbd8f4054168da6e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e7173c8a68261e3947a57eca91d407b6501f7deca789f7d9fde3456837d884b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/j178/leetgo/constants.Version=#{version}
      -X github.com/j178/leetgo/constants.Commit=#{tap.user}
      -X github.com/j178/leetgo/constants.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"leetgo", "completion")
  end

  test do
    assert_match "leetgo version #{version}", shell_output("#{bin}/leetgo --version")
    system bin/"leetgo", "init"
    assert_path_exists testpath/"leetgo.yaml"
  end
end