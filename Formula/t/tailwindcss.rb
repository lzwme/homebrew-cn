class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https:tailwindcss.com"
  url "https:registry.npmjs.orgtailwindcss-tailwindcss-4.0.0.tgz"
  sha256 "72309ed7264bb66a0e4ed4171a064f9f4ea3b92906afe67b8afedbd8f9e78b28"
  license "MIT"
  head "https:github.comtailwindlabstailwindcss.git", branch: "next"

  # There can be a notable gap between when a version is added to npm and the
  # GitHub release is created, so we check the "latest" release on GitHub
  # instead of the default `Npm` check for the `stable` URL.
  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "6a0c3745b4c7006283ae59f9a456bd3061d31838eab5c02ddc90f62c8a381ecc"
    sha256                               arm64_sonoma:  "c97e47d897aa2b72420224639af7e7843ad6277564ae6e570c79cbc50e8cc5e6"
    sha256                               arm64_ventura: "5508f6e69acfc9edd08303948327aebd434d9acbdd66bea745ccfbd6f1ce8aca"
    sha256                               sonoma:        "12d7fae1500719207be8f1afa619e9f8ab0222b76712f9f02da43e6b7c181b8e"
    sha256                               ventura:       "fae76c41673de7042fd257448fbc58b43b23cf56559c1e86f6ef662e753448fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9781a9730ee133a7218f96d5bd720ca96aed67d70bd0ae5ec9d0a56a5036930e"
  end

  depends_on "node"

  resource "tailwind-cli" do
    url "https:registry.npmjs.org@tailwindcsscli-cli-4.0.0.tgz"
    sha256 "a6a772944d048966e9db2bdc7521053ea3d8bd06cfdff7931fdc4bb2313e6369"
  end

  def install
    # install the dedicated tailwind-cli package
    resource("tailwind-cli").stage do
      system "npm", "install", *std_npm_args
    end

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")
  end

  test do
    (testpath"input.css").write("@tailwind base;")
    system bin"tailwindcss", "-i", "input.css", "-o", "output.css"
    assert_path_exists testpath"output.css"
  end
end