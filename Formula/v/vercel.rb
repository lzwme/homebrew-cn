class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-58.7.1.tgz"
  sha256 "83dd6802124152fc64d475b7a60ecbef28f11bd7abb23c0d45d8b9e5db354f69"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32ef28a760dfa29a4005b3146bfb10e890dda79d7f75a9cbfa74f5cd2f579943"
    sha256 cellar: :any,                 arm64_sequoia: "32ef28a760dfa29a4005b3146bfb10e890dda79d7f75a9cbfa74f5cd2f579943"
    sha256 cellar: :any,                 arm64_sonoma:  "32ef28a760dfa29a4005b3146bfb10e890dda79d7f75a9cbfa74f5cd2f579943"
    sha256 cellar: :any,                 sonoma:        "714b6d1b07ca4aa0b555461708e713615379e43105e01a7ddae2116c6d46c248"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adc0fbee7ad6d273c1ad4d406fb4210548bc211719e5860fdff4b48e9d6d4d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad35800aed2023e444a4871dc3a2f7bfa58ba6c8e77084fd8187ceb82bc3b3c0"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    (node_modules/"@vercel/go/bin").glob("**/proxy-*").each do |f|
      next if OS.linux? && f.arch == Hardware::CPU.arch

      rm f
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end