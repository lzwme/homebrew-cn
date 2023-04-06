require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.8.0.tgz"
  sha256 "59ea2d45a434cd6cf39f493f748e5f4ee7277112ac605eb90dd7479db24179fc"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "c2ba07725192766e97a5272e16a84f0f5a479536c07509021b8a69ce28572900"
    sha256                               arm64_monterey: "81e6441752da81ccbb18491ced54e6d1aece9ed964485096f6f4216c3d263c29"
    sha256                               arm64_big_sur:  "37f67798b714f5ce05b47ce339d3d3d9293c437ad10fc9055e8fac5129a5764e"
    sha256                               ventura:        "dce4142b496668ad01c8c09deec1fd80e953953776045e3b44446683ac07c909"
    sha256                               monterey:       "2f825a5915791f8f68a049dc7f25eee4d070a829813ab656b2158bc35923c670"
    sha256                               big_sur:        "bba8352c4a140c6c48a396864b38417107d7df46dcb059cf32c36f0d931889f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50651ccec2ea59e6bd2033d4508ad0bdda2d010698df9aacf740f03b6c4b29a1"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/#{name}/node_modules"
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    if OS.linux?
      %w[@lmdb/lmdb @msgpackr-extract/msgpackr-extract].each do |mod|
        node_modules.glob("#{mod}-linux-#{arch}/*.musl.node")
                    .map(&:unlink)
                    .empty? && raise("Unable to find #{mod} musl library to delete.")
      end
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end