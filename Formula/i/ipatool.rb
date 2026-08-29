class Ipatool < Formula
  desc "CLI tool for searching and downloading app packages from the iOS App Store"
  homepage "https://github.com/majd/ipatool"
  url "https://ghfast.top/https://github.com/majd/ipatool/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "95bb79d983b30a90d10bd4b326fc384ce7896abaf0626989ff463a36930c9f12"
  license "MIT"
  head "https://github.com/majd/ipatool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1769c388474064511407b2ede4ebd0f72ede3c49ae64b4ec09b788e1b360638"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60e8813943fc8427b4f3249cdc93d240995f261c4aef59df85795ed437e7775d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87979f77aa7097f7a70f4b6df9e452fea768b666e52c94d218583880724ee97a"
    sha256 cellar: :any,                 arm64_linux:   "a7d877442455178be6f5b0cbe5a3176466663cbad2664d786f82a55a2ba4e350"
    sha256 cellar: :any,                 x86_64_linux:  "205c2e185b6f8d9697f26fe3dfc0101a49cba006f013170432a19df5e3da3bb2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-X github.com/majd/ipatool/v2/cmd.version=#{version}")

    generate_completions_from_executable(bin/"ipatool", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipatool --version")

    output = shell_output("#{bin}/ipatool auth info 2>&1", 1)
    assert_match "failed to get account", output
  end
end