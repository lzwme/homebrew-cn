class TrzszSsh < Formula
  desc "Simple ssh client with trzsz ( trz  tsz ) support"
  homepage "https:trzsz.github.iossh"
  url "https:github.comtrzsztrzsz-ssharchiverefstagsv0.1.15.tar.gz"
  sha256 "2b9fb3b0a8be72fa785da5c9f6af7c2ab8f7d9b821ebb464d764c8f395d61308"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b21c95f713d33001d2a25384937cd1ba701cca942f267399e3a6fc2e888f0bc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2781bffccc4f4b101d0b5c189d24ddfe83bc09ffdf375dffc405ff5add94b882"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96f607ad7eb6063e34329a1c15fc794af0f4bef8c93e5c468dc91a99f25d7f3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "01e0a367a24770a6151bec707f9d98deed208391c475e77ad5376b55d3467919"
    sha256 cellar: :any_skip_relocation, ventura:        "65801bd9f54e34a29668d0a1533a3cea1d02f5db8c92c28e6cff448a6c4827ce"
    sha256 cellar: :any_skip_relocation, monterey:       "49b600e34346a01574fa4371ddab36768b7bc9a544edf3f8ac4e39f40ff5e917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8ec551c63d651c2670086161babecd4a57f6db1c1fbfc085da0ac9078ae4375"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"tssh"), ".cmdtssh"
  end

  test do
    assert_match "trzsz ssh #{version}", shell_output("#{bin}tssh -V")
    assert_match "trzsz ssh #{version}", shell_output("#{bin}tssh --version")

    assert_match "invalid option", shell_output("#{bin}tssh -o abc", 255)
    assert_match "invalid bind specification", shell_output("#{bin}tssh -D xyz", 255)
    assert_match "invalid forward specification", shell_output("#{bin}tssh -L 123", 255)
  end
end