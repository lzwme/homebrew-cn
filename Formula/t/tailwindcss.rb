class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https:tailwindcss.com"
  url "https:registry.npmjs.org@tailwindcsscli-cli-4.1.6.tgz"
  sha256 "84b9f4f6be5959a782aef1c6be5ab2b761b2652f9fc70ffd2897a3bfcfe949a4"
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
    sha256                               arm64_sequoia: "12fa8ef97f0b074efb90db9a1745040f64e4d54e7bcf234cda9d44743adc096e"
    sha256                               arm64_sonoma:  "5534d455c9af158e6e663ef28ae30ac341c32fa5660b92b5ba4289a555e9a631"
    sha256                               arm64_ventura: "b5185080dce1ab0eb8ff3d6119eac74d397a1fd0bf6824ed04efa1a8de61b821"
    sha256                               sonoma:        "d7684af1a1c542a60a62d4c4e6bd91304789f37dce9562b2497f61b10fe76bf3"
    sha256                               ventura:       "dd34317bc26714ad0b620a0a97051408601c7f1b60fc53b6d9b309f171419951"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d02c9c95f136d3e6fccde8bfd36468dbd3d7268f817e13bcc3ee7b4729d2c56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04e40e5aebe1d0f7774292c521c7705d3a53ff045f29d1f801e1c00dce01ee8d"
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