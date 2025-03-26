class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https:tailwindcss.com"
  url "https:registry.npmjs.org@tailwindcsscli-cli-4.0.16.tgz"
  sha256 "e4ea8cd99161ba16aa055dc059b70e6188b713181624fda9e2e4965001c4e1f3"
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
    sha256                               arm64_sequoia: "e23ae1cfa1ff5caaf92fd26ea147e90a6c24800de742f9f70393bc023054b61a"
    sha256                               arm64_sonoma:  "7ec5fd8ddf5c8b5f47b566306ee542a1df9660d640c5c103eb35ee8da210cbf0"
    sha256                               arm64_ventura: "209d7c9d937470f580ec56560260c549a31d45dadf9807ffcfcf02d47da7d851"
    sha256                               sonoma:        "0dc13e3fc22766ca9b34895a763e98633b5dbd0301847011dbff7fcc12ae9429"
    sha256                               ventura:       "59eedf7644b2fdec95839537ed961b97228c810504633134f65f00b4578437da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b1f3aba559018b120716e31be107b833200ef5bf5f56d50cfb6defd10b99ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "351a3fbc6d3aabbc31213b937747eb2248f2e10ff664dc4a01c63d64e6a2ddf0"
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