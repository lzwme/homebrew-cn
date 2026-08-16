class Classifier < Formula
  desc "Text classification with Bayesian, LSI, Logistic Regression, and kNN"
  homepage "https://rubyclassifier.com"
  url "https://ghfast.top/https://github.com/cardmagic/classifier/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "3e0cf89c758eb4e7cb96a24dd39a422ec55c742d9663ee5fbb7fc63433deb872"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f443d16f0a1138701b3ef07935c3209d3ed3ab21bbdacbc1508ba26f2a69a374"
    sha256 cellar: :any, arm64_sequoia: "dad6fc29671e905a7f01f5bcc792607b2b69f8e54b6f5f2f5d7a67ef84270aca"
    sha256 cellar: :any, arm64_sonoma:  "e374ef33c6049031f61d0938201d1a1599dcdf04681f85f200012f9059dfbd37"
    sha256 cellar: :any, sonoma:        "6cd35ad2db7be955bd6979632f02164c2cca364b8419cca427217d39a242b601"
    sha256 cellar: :any, arm64_linux:   "0b9b27c8f0797dc96ae847b3c0ade46b1f5a5ff3fdfc7687005cb1e040ce06c9"
    sha256 cellar: :any, x86_64_linux:  "c677f8b26275509284121958b3de6a984df6a38a7d9dd8cdba7c9ac0a90cf4cf"
  end

  depends_on "ruby"

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system"
    ENV["BUNDLE_WITHOUT"] = "development:test"
    ENV["GEM_HOME"] = libexec

    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "#{name}-#{version}.gem"

    bin.install libexec/"bin/classifier"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/classifier --version")

    # Test with pre-trained remote model (SMS spam detection)
    output = shell_output("#{bin}/classifier -r sms-spam-filter 'You won a free iPhone'")
    assert_match "spam", output.downcase

    output = shell_output("#{bin}/classifier -r sms-spam-filter 'Meeting at 3pm tomorrow'")
    assert_match "ham", output.downcase
  end
end