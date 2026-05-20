class Classifier < Formula
  desc "Text classification with Bayesian, LSI, Logistic Regression, and kNN"
  homepage "https://rubyclassifier.com"
  url "https://ghfast.top/https://github.com/cardmagic/classifier/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "3cba254e0e8a86fd45081454c639428e32216f491c87f0492489f3381ccf7c96"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "78fc0a23d36c7b17f721334bac534e1849320310d58c7a0aebb87fd28a512ab7"
    sha256 cellar: :any,                 arm64_sequoia: "97d795ffe3575cab0c124aa5c709b6d986f14572a58282f1a731b4af6db3927d"
    sha256 cellar: :any,                 arm64_sonoma:  "c5e09d43a6323a05776ec07d8095091f0ac2eb536704df4d07535bbc373faed0"
    sha256 cellar: :any,                 sonoma:        "06f404aada73fb354d2013eb8cb202a3e2a79d8fc2400d7935c3e569a95fb5dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f83f13ba9fd189a54af0f03ba8497bc55a75a6684e918b2a7200cdcf1037fc01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d6d09ba0944e59c6f5b5c6a4c105f3d166a6b91d7fac423ffe3f9701e429eb9"
  end

  depends_on "ruby"

  def install
    ENV["BUNDLE_VERSION"] = "system"
    ENV["BUNDLE_WITHOUT"] = "development:test"
    ENV["GEM_HOME"] = libexec

    system "bundle", "install"
    system "gem", "build", "classifier.gemspec"
    system "gem", "install", "classifier-#{version}.gem"

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