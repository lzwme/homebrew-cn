class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https:tailwindcss.com"
  url "https:registry.npmjs.org@tailwindcsscli-cli-4.1.0.tgz"
  sha256 "6aec338b83d5152d75973fd2bf63c31f47a1b0b69cdfb1888c995fcc727c1e45"
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
    sha256                               arm64_sequoia: "a6c5b1c169962a39b2df81b9ed2922e89836a3b96f9b823ae2cba878629a386e"
    sha256                               arm64_sonoma:  "940b7ad40ec58ecca47f34123dd63b0d48ff11317a6f04539a4ab425b201f73a"
    sha256                               arm64_ventura: "40411361f8eae64468c20f77bf7cf62a63798a22d4b65402221da3e01a29dc30"
    sha256                               sonoma:        "25839e0e78694a4601bff85cc3776c83f677339d680669e4737dd61c217a8bca"
    sha256                               ventura:       "8b16b67edec3466cb10df864f1936ef1cbec543eb70a4c00d808be5bf0ecad63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db4d8f7f1d017376a2fcf68685c36b3b562c9e1a5e4f7a0901093ff8f72fa145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "093a0a6dc6e9e9b14cb918f0e5d7f0314b4d22d8f247b365801d43e9ecf2913a"
  end

  depends_on "node"

  # Imitate standalone CLI and include first-party plugins
  # https:github.comtailwindlabstailwindcssblobmainpackages%40tailwindcss-standalonepackage.json#L28-L31
  resource "@tailwindcssaspect-ratio" do
    url "https:registry.npmjs.org@tailwindcssaspect-ratio-aspect-ratio-0.4.2.tgz"
    sha256 "858df3d82234e12e59e6f8bd5d272d1e6c65aefcb4263dac84d0331f5ef00455"
  end

  resource "@tailwindcssforms" do
    url "https:registry.npmjs.org@tailwindcssforms-forms-0.5.10.tgz"
    sha256 "f5003f088c8bfeef2d2576932b0521e29f84b7ca68e59afd709fef75bd4fe9bb"
  end

  resource "@tailwindcsstypography" do
    url "https:registry.npmjs.org@tailwindcsstypography-typography-0.5.16.tgz"
    sha256 "41bb083cd966434072dd8a151c8989e1cfa574eb5ba580b719da013d32b6828e"
  end

  def install
    resources.each do |r|
      system "npm", "install", *std_npm_args(prefix: false), r.cached_download
    end
    system "npm", "install", *std_npm_args
    bin.install libexec.glob("bin*")
    bin.env_script_all_files libexec"bin", NODE_PATH: libexec"libnode_modules@tailwindcssclinode_modules"
  end

  test do
    # https:github.comtailwindlabstailwindcssblobmainintegrationsclistandalone.test.ts
    (testpath"index.html").write <<~HTML
      <div className="prose">
        <h1>Headline<h1>
      <div>
      <input type="text" class="form-input" >
      <div class="aspect-w-16"><div>
    HTML

    (testpath"input.css").write <<~CSS
      @tailwind base;
      @import "tailwindcss";
      @import "tailwindcsstheme" theme(reference);
      @import "tailwindcssutilities";

      @plugin "@tailwindcssforms";
      @plugin "@tailwindcsstypography";
      @plugin "@tailwindcssaspect-ratio";
    CSS

    system bin"tailwindcss", "--input", "input.css", "--output", "output.css"
    assert_path_exists testpath"output.css"

    output = (testpath"output.css").read
    assert_match ".form-input {", output
    assert_match ".prose {", output
    assert_match ".aspect-w-16 {", output
  end
end