cask "android-ndk" do
  version "27b"
  sha256 "cc4855aa847bedc69bab461da8f5400a90b02f8d259fb0a1407a20cd7a791a19"

  url "https:dl.google.comandroidrepositoryandroid-ndk-r#{version}-darwin.dmg",
      verified: "dl.google.comandroidrepository"
  name "Android NDK"
  desc "Toolset to implement parts of Android apps in native code"
  homepage "https:developer.android.comndkindex.html"

  livecheck do
    url "https:developer.android.comndkdownloads"
    regex(Latest\b(?!\s+Beta|\s+Pre-Release).*?r(\d+[a-z]?)i)
  end

  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}ndk_exec.sh"
  preflight do
    build = File.read("#{staged_path}source.properties").match((?<=Pkg.Revision\s=\s\d\d.\d.)\d+)
    FileUtils.ln_sf("#{staged_path}AndroidNDK#{build}.appContentsNDK", "#{HOMEBREW_PREFIX}shareandroid-ndk")

    File.write shimscript, <<~EOS
      #!binbash
      readonly executable="#{staged_path}AndroidNDK#{build}.appContentsNDK$(basename ${0})"
      test -f "${executable}" && exec "${executable}" "${@}"
    EOS
  end

  %w[
    ndk-build
    ndk-depends
    ndk-gdb
    ndk-stack
    ndk-which
  ].each { |link_name| binary shimscript, target: link_name }

  uninstall_postflight do
    FileUtils.rm("#{HOMEBREW_PREFIX}shareandroid-ndk")
  end

  # No zap stanza required

  caveats <<~EOS
    You may want to add to your profile:
       'export ANDROID_NDK_HOME="#{HOMEBREW_PREFIX}shareandroid-ndk"'
  EOS
end