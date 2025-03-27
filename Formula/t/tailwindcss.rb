class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https:tailwindcss.com"
  url "https:registry.npmjs.org@tailwindcsscli-cli-4.0.17.tgz"
  sha256 "3d8f61c8f66f70953da9e69693f3ccef09211fff692ed963c6330ae0862df7d0"
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
    sha256                               arm64_sequoia: "9ae3b30816628498adf122d534dfc7ea5ada522113c4a55c59c1a55e94982ec3"
    sha256                               arm64_sonoma:  "ae006d7289e938bb5805e46938475d1937e4c7082909fe4234cdcee0a3d4edbd"
    sha256                               arm64_ventura: "0c1bdd439d820af95ac2b98e4cc85a0481ad9a273e53f9923475e8bcae55b469"
    sha256                               sonoma:        "fe43c737fab6700923f0f2d15646759d82f19bed11cee403d20bd4d468f12d8b"
    sha256                               ventura:       "e178e93f1936f7b3c9b77b7da5b55108480940c6f3391a8f73a533f353458535"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13483ce87c95e382304a3542eb70f2e0bf30fd296fb4e0840225a51e72dcdba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5aaf0377408c9f467ea78294a44ae44667c801e5a4bb7204e957b3744ff77e4d"
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