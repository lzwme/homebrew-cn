class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.35.0.tgz"
  sha256 "f954bb0f31d38d8b80ed3183de1dc14604ff1f36d9e82ba1b3b91af77a953664"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "292c6c541bdbbc96bb56ee6804c89982edfb796e82084017bde57bcfb60a5484"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "292c6c541bdbbc96bb56ee6804c89982edfb796e82084017bde57bcfb60a5484"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "292c6c541bdbbc96bb56ee6804c89982edfb796e82084017bde57bcfb60a5484"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e9caca6c70e339514eceae7dbd71c109e01a36a715a7991c723bd545b2518c5"
    sha256 cellar: :any_skip_relocation, ventura:        "3e9caca6c70e339514eceae7dbd71c109e01a36a715a7991c723bd545b2518c5"
    sha256 cellar: :any_skip_relocation, monterey:       "3e9caca6c70e339514eceae7dbd71c109e01a36a715a7991c723bd545b2518c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "292c6c541bdbbc96bb56ee6804c89982edfb796e82084017bde57bcfb60a5484"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion", base_name: cmd, shells: [:bash, :zsh])
    end
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end