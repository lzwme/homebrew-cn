class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.17.0.tgz"
  sha256 "95f2f1482d448349b4e53a07c368ca8a4806e450036604176ac55179b0b5b2b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6f86dc4705867597683a51b14ce07730ed61bd6cc10abde265408cd2921ccf2d"
    sha256 cellar: :any,                 arm64_sequoia: "9ad81ae89a68565ed8ec9ef19d8d1b352870b53feea4d409fa2841b7830b00bd"
    sha256 cellar: :any,                 arm64_sonoma:  "9ad81ae89a68565ed8ec9ef19d8d1b352870b53feea4d409fa2841b7830b00bd"
    sha256 cellar: :any,                 sonoma:        "3036f678cb7a2b5a0eedd321bc971db7e1734a8ba878aae1fa53ee79474d536a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bd75669d28b2898a188afdc3d095ff87462487d915e23dd61737abdc98d1872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "402b43d2ed4f420db7bbbd7ce27dedef0ed994be1d5fc55e3b6c91e4adbfd380"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

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