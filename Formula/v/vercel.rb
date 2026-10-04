class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-62.2.0.tgz"
  sha256 "68a81cdbc5f8dd0b5a63d41fc702d97d28d65c6d1b473cb2f55142eaabd5be26"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "367a74eb583edde08dee697570407a61c180c11d33d6070f7d49cb691ae207bd"
    sha256 cellar: :any,                 arm64_tahoe:       "367a74eb583edde08dee697570407a61c180c11d33d6070f7d49cb691ae207bd"
    sha256 cellar: :any,                 arm64_sequoia:     "367a74eb583edde08dee697570407a61c180c11d33d6070f7d49cb691ae207bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "355ec66613054c4034002b9fff06607cccb15b92444d8b4093103eb8f13fe3e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8031d87db03df1bb841b7246fc12c124796a4b32a883f6108aff4fdf9ad3ee9a"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    proxy_arch = Hardware::CPU.intel? ? "amd64" : "arm64"
    ["@vercel/go", "@vercel/rust"].each do |package|
      (node_modules/package/"bin").glob("**/proxy-*").each do |f|
        next if OS.linux? && f.basename.to_s == "proxy-linux-#{proxy_arch}"

        rm f
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end