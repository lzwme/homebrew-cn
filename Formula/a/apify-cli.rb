class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.20.11.tgz"
  sha256 "bb3f81451435fa6bcc511c94e730b274059258f087999fb659c504ef97aecc62"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6938df875becc3fc1cfa2158ff848901ad1e91963aeb8494350fba002a6a3a0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6938df875becc3fc1cfa2158ff848901ad1e91963aeb8494350fba002a6a3a0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6938df875becc3fc1cfa2158ff848901ad1e91963aeb8494350fba002a6a3a0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbfc492ab2d5afb89cfb16c5ee75d78787f6868957177a6e3eb930304cb0eeef"
    sha256 cellar: :any_skip_relocation, ventura:       "bbfc492ab2d5afb89cfb16c5ee75d78787f6868957177a6e3eb930304cb0eeef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d4d9ecb6cb18cb0694f392a9706927508642ed3971c5ccb58c20d9182a55689"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_predicate testpath/"storage/key_value_stores/default/INPUT.json", :exist?

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end