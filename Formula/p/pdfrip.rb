class Pdfrip < Formula
  desc "Multi-threaded PDF password cracking utility"
  homepage "https://github.com/mufeedvh/pdfrip"
  url "https://ghfast.top/https://github.com/mufeedvh/pdfrip/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "60f284d79bac98c97e6eaa1a2f29d66055de5b3c8a129eb14b24057a7cb31cd3"
  license "MIT"
  head "https://github.com/mufeedvh/pdfrip.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "292ebaf47ad267c46b92b1bac0867f40de7b5b8da18e76c52b47f9f0149165a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8339046b619269dfb1ff6a34ee7600b08d12b3e010f81be19651156a1a8f8fe5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5f63f9f61786ae79b683dee924b74fd24714fec9e26e7b610f7ce7069686123"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0667d550093d933128888b11e30b76dfa07dae2407c9c1fadab94d95c17a96d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db6c977f9189f34246c8a3cddbbcbc24d2bb6b10436affc8b787e47675d46b4a"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  # Fix to build error with `indicatif`
  # PR ref: https://github.com/mufeedvh/pdfrip/pull/64
  patch :DATA

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdfrip --version")

    touch testpath/"test.pdf"
    output = shell_output("#{bin}/pdfrip -f test.pdf range 1 5 2>&1")
    assert_match "Failed to crack file", output
  end
end

__END__
diff --git a/Cargo.toml b/Cargo.toml
index e0db059..8063d89 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -5,7 +5,7 @@ edition = "2021"
 authors = ["Mufeed VH <mufeed@lyminal.space>", "Pommaq"]
 
 [dependencies]
-indicatif = "0.16.2"
+indicatif = "0.18.0"
 log = "0.4.19"
 anyhow = "1.0.72"
 crossbeam = "0.8.2"
diff --git a/src/core/engine.rs b/src/core/engine.rs
index 29980ee..093362a 100644
--- a/src/core/engine.rs
+++ b/src/core/engine.rs
@@ -49,8 +49,8 @@ pub fn crack_file(
 
     let progress_bar = ProgressBar::new(producer.size() as u64);
-    progress_bar.set_draw_delta(1000);
-    progress_bar.set_style(ProgressStyle::default_bar()
-        .template("{spinner:.green} [{elapsed_precise}] [{bar:40.cyan/blue}] {pos:>7}/{len:7} {percent}% {per_sec} ETA: {eta}"));
+    let style = ProgressStyle::default_bar()
+            .template("{spinner:.green} [{elapsed_precise}] [{bar:40.cyan/blue}] {pos:>7}/{len:7} {percent}% {per_sec} ETA: {eta}")?;
+    progress_bar.set_style(style);
 
     loop {
         match success_reader.try_recv() {