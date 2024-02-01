require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.163.0.tgz"
  sha256 "ce6b2ae444cdf52b399f110c5f4a1cdcca93f10c20c3606b5ab31afb2bfc6225"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https:registry.npmjs.orgrenovatelatest"
    regex(v?(\d+(?:\.\d+)+)i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ab2330fb051d434105080d0dd63c6d28400ac954af40ef983cf2d7cda77d078"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbe426656bb32229c5493c35c912d91a1a55a04ae6ca88a46c05d6dabe1b5a68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe9f96970c3dbc5f4a261b285ede0ba9ac718e1df56c7bb450dc0f740cee5422"
    sha256 cellar: :any_skip_relocation, sonoma:         "614031196adc3d5b5e56d8727825afb63ed054258f48966d85799e5203816312"
    sha256 cellar: :any_skip_relocation, ventura:        "f8ebe65daa1917275b685c2c033ff13c265f5a7fc229609bf8002b4c9fcc117b"
    sha256 cellar: :any_skip_relocation, monterey:       "406359053c36fae260c85bd9135a91b495f15544e570b93638fccc9b0501c06b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "085180f9debf6a3bd6a659b99df49c30f56f2cb79c826123d697d5f229f2f634"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end