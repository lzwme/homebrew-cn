class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://registry.npmjs.org/@tailwindcss/cli/-/cli-4.2.1.tgz"
  sha256 "bd25c3e5d4d7432e8ea0dbbb564ff806f984c88b3a3d6fede210d51ddd402916"
  license "MIT"
  head "https://github.com/tailwindlabs/tailwindcss.git", branch: "main"

  # There can be a notable gap between when a version is added to npm and the
  # GitHub release is created, so we check the "latest" release on GitHub
  # instead of the default `Npm` check for the `stable` URL.
  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e6ce1156598043de5f062b97c52ad3cd8386254e59ab34aa5cacc691b62f3a1"
    sha256 cellar: :any,                 arm64_sequoia: "9cb10230e4807b75ba5f1e3fe1f69b5f27bfc2c4f71a334d82ed8151ed48def0"
    sha256 cellar: :any,                 arm64_sonoma:  "9cb10230e4807b75ba5f1e3fe1f69b5f27bfc2c4f71a334d82ed8151ed48def0"
    sha256 cellar: :any,                 sonoma:        "8b75318e3ca27d1fdb867761182e3f63e9cd0596830deb7baa86f66b5d1ccda7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "490c7b63b7696ace096ac109ca93932c793065d457a60387c9b3c067dadb5cd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f103210391d714da0af3c7223c6f891129628a1810af904e83bbd2fbdc108864"
  end

  depends_on "node"

  # Imitate standalone CLI and include first-party plugins
  # https://github.com/tailwindlabs/tailwindcss/blob/main/packages/%40tailwindcss-standalone/package.json#L28-L31
  resource "@tailwindcss/aspect-ratio" do
    url "https://registry.npmjs.org/@tailwindcss/aspect-ratio/-/aspect-ratio-0.4.2.tgz"
    sha256 "858df3d82234e12e59e6f8bd5d272d1e6c65aefcb4263dac84d0331f5ef00455"
  end

  resource "@tailwindcss/forms" do
    url "https://registry.npmjs.org/@tailwindcss/forms/-/forms-0.5.11.tgz"
    sha256 "6180fcab09668a498d17c89ca11b54825c5ee6b6fc6d1343ad6fa558d9828c50"
  end

  resource "@tailwindcss/typography" do
    url "https://registry.npmjs.org/@tailwindcss/typography/-/typography-0.5.19.tgz"
    sha256 "0490006975cde689af548a2755f9c263344b7896f7fcc1d6b6f6680b59af3465"
  end

  def install
    resources.each do |r|
      system "npm", "install", *std_npm_args(prefix: false), r.cached_download
    end
    system "npm", "install", *std_npm_args
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files libexec/"bin", NODE_PATH: libexec/"lib/node_modules/@tailwindcss/cli/node_modules"
  end

  test do
    # https://github.com/tailwindlabs/tailwindcss/blob/main/integrations/cli/standalone.test.ts
    (testpath/"index.html").write <<~HTML
      <div className="prose">
        <h1>Headline</h1>
      </div>
      <input type="text" class="form-input" />
      <div class="aspect-w-16"></div>
    HTML

    (testpath/"input.css").write <<~CSS
      @tailwind base;
      @import "tailwindcss";
      @import "tailwindcss/theme" theme(reference);
      @import "tailwindcss/utilities";

      @plugin "@tailwindcss/forms";
      @plugin "@tailwindcss/typography";
      @plugin "@tailwindcss/aspect-ratio";
    CSS

    system bin/"tailwindcss", "--input", "input.css", "--output", "output.css"
    assert_path_exists testpath/"output.css"

    output = (testpath/"output.css").read
    assert_match ".form-input {", output
    assert_match ".prose {", output
    assert_match ".aspect-w-16 {", output
  end
end