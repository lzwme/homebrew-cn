class SwiftOutdated < Formula
  desc "Check for outdated Swift package manager dependencies"
  homepage "https://github.com/kiliankoe/swift-outdated"
  url "https://ghfast.top/https://github.com/kiliankoe/swift-outdated/archive/refs/tags/0.9.1.tar.gz"
  sha256 "0f03f6771603df17bf0d64ff73a8f026d48ee33d0084eb33b88b5405aee39071"
  license "MIT"
  head "https://github.com/kiliankoe/swift-outdated.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58aeea76403eca1144530d12d17f6fa5a6948034cb075cb5a3b1014461f0a396"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59a7de084662bdadeb04796bcd11046d6ee063931e5b01f5ab3792b3486d92a7"
    sha256 cellar: :any,                 arm64_ventura: "62239578f238bf0236695dad01d98c639260eaca52438a8de0cf2ae86de74510"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d1604bc3df90d6939ce16b57ef779c57a79f7b84558e6d2512fccb1c6af4e82"
    sha256 cellar: :any,                 ventura:       "89fb9b983054d10d5a9df8a29be708a4216e1c434d5b981d47c7abb9b791068d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7667824b4932a49ee6a49349c37a7806541a872b7320f2aca2216aeb64ced9b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25992defbbb5f13ee4cfadf31b3293691ea40298c8e75ee54bdcdc08556cbdb8"
  end

  uses_from_macos "swift" => :build, since: :sonoma # swift 6.0+

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release"
    bin.install ".build/release/swift-outdated"
    generate_completions_from_executable(bin/"swift-outdated", "--generate-completion-script")
  end

  test do
    assert_match "No Package.resolved found", shell_output("#{bin}/swift-outdated 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/swift-outdated --version")
  end
end